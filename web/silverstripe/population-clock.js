/**
 * Population Clock JavaScript for SilverStripe
 * Handles multiple instances on the same page
 */
(function() {
  'use strict';
  
  class PopulationClock {
    constructor(element) {
      this.element = element;
      this.id = element.querySelector('.main-count').id.split('-').pop();
      this.apiUrl = element.dataset.apiUrl || 'https://popclock-api.onrender.com/clock/estimate?format=json';
      
      // Configuration
      this.SYNC_INTERVAL = 30000; // ms between backend syncs
      this.TIMESTAMP_UPDATE_INTERVAL = 1000; // ms between timestamp updates
      
      // Population change rates (seconds)
      this.POPULATION_CHANGE_INTERVAL = 21 * 60 + 2;
      this.BIRTH_INTERVAL = 9 * 60 + 1;
      this.DEATH_INTERVAL = 14 * 60 + 46;
      this.MIGRATION_INTERVAL = 3 * 3600 + 52 * 60 + 9;

      // State
      this.lastData = null;
      this.lastTimestamp = null;
      this.baseTimestamp = null;
      this.currentTime = new Date();
      this.intervals = [];
      
      this.init();
    }
    
    extractValue(x) {
      if (Array.isArray(x)) {
        return x.length > 0 ? x[0] : 0;
      }
      return x;
    }
    
    setText(elementId, value) {
      const element = document.getElementById(elementId);
      if (element) {
        element.textContent = value;
      }
    }
    
    updateTimestamp() {
      this.currentTime = new Date();
      this.setText(`nz-timestamp-${this.id}`, "Updated: " + this.currentTime.toLocaleString());
    }
    
    updatePopulationEstimates() {
      if (!this.lastData || !this.baseTimestamp) return;
      
      const now = new Date();
      const elapsedSeconds = (now - this.baseTimestamp) / 1000;
      
      // Calculate changes
      const populationIncrease = Math.floor(elapsedSeconds / this.POPULATION_CHANGE_INTERVAL);
      const birthIncrease = Math.floor(elapsedSeconds / this.BIRTH_INTERVAL);
      const deathIncrease = Math.floor(elapsedSeconds / this.DEATH_INTERVAL);
      const migrationIncrease = Math.floor(elapsedSeconds / this.MIGRATION_INTERVAL);
      
      // Update estimates
      const newPop = this.extractValue(this.lastData.estimate) + populationIncrease;
      const newBirths = this.extractValue(this.lastData.births) + birthIncrease;
      const newDeaths = this.extractValue(this.lastData.deaths) + deathIncrease;
      const newMigration = this.extractValue(this.lastData.migration) + migrationIncrease;
      
      // Update UI
      this.setText(`nz-pop-estimate-${this.id}`, newPop.toLocaleString());
      this.setText(`nz-births-${this.id}`, newBirths.toLocaleString());
      this.setText(`nz-deaths-${this.id}`, newDeaths.toLocaleString());
      this.setText(`nz-migration-${this.id}`, newMigration.toLocaleString());
    }
    
    async fetchAndReset() {
      try {
        const resp = await fetch(this.apiUrl);
        if (!resp.ok) throw new Error("API error: " + resp.status);
        const data = await resp.json();

        const estimate = this.extractValue(data.estimate);
        const births = this.extractValue(data.births);
        const deaths = this.extractValue(data.deaths);
        const migration = this.extractValue(data.migration);
        const timestamp = this.extractValue(data.timestamp);

        this.lastData = data;
        this.lastTimestamp = new Date(timestamp.replace(' ', 'T') + 'Z');
        this.baseTimestamp = new Date();
        
        this.setText(`nz-pop-estimate-${this.id}`, estimate.toLocaleString());
        this.setText(`nz-births-${this.id}`, births.toLocaleString());
        this.setText(`nz-deaths-${this.id}`, deaths.toLocaleString());
        this.setText(`nz-migration-${this.id}`, migration.toLocaleString());
        this.setText(`nz-timestamp-${this.id}`, "Data as at: " + timestamp + " UTC");
        
        this.updatePopulationEstimates();
      } catch (e) {
        console.error('Population Clock API Error:', e);
        this.setText(`nz-pop-estimate-${this.id}`, "Error!");
        this.setText(`nz-timestamp-${this.id}`, "API not reachable or returned error.");
        this.setText(`nz-births-${this.id}`, "0");
        this.setText(`nz-deaths-${this.id}`, "0");
        this.setText(`nz-migration-${this.id}`, "0");
      }
    }
    
    init() {
      // Clear any existing intervals
      this.destroy();
      
      // Start the clock
      this.fetchAndReset();
      this.intervals.push(setInterval(() => this.fetchAndReset(), this.SYNC_INTERVAL));
      this.intervals.push(setInterval(() => this.updateTimestamp(), this.TIMESTAMP_UPDATE_INTERVAL));
      this.intervals.push(setInterval(() => this.updatePopulationEstimates(), this.POPULATION_CHANGE_INTERVAL * 1000));
    }
    
    destroy() {
      // Clean up intervals
      this.intervals.forEach(interval => clearInterval(interval));
      this.intervals = [];
    }
  }
  
  // Initialize all population clock instances on the page
  function initializePopulationClocks() {
    const elements = document.querySelectorAll('.nz-population-clock-element');
    elements.forEach(element => {
      if (!element.populationClock) {
        element.populationClock = new PopulationClock(element);
      }
    });
  }
  
  // Auto-initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializePopulationClocks);
  } else {
    initializePopulationClocks();
  }
  
  // Re-initialize if new content is loaded via AJAX (common in SilverStripe)
  document.addEventListener('ss-element-loaded', initializePopulationClocks);
  
  // Expose for manual control
  window.PopulationClock = PopulationClock;
  window.initializePopulationClocks = initializePopulationClocks;
})();