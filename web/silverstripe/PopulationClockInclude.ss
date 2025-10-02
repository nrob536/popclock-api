<div class="nz-population-clock-include" data-api-url="https://popclock-api.onrender.com/clock/estimate?format=json">
  <div class="clock-container">
    <div class="main-count" id="nz-pop-estimate-include">Loading…</div>
    <div class="sub-counts">
      <div>Births: <span id="nz-births-include">0</span></div>
      <div>Deaths: <span id="nz-deaths-include">0</span></div>
      <div>Net migration: <span id="nz-migration-include">0</span></div>
    </div>
    <div class="timestamp" id="nz-timestamp-include"></div>
  </div>
  
  <div class="caveat">
    <h3>About the Population Clock</h3>
    <p>New Zealand's population is estimated to increase by one person every 21 minutes and 2 seconds.</p>
    <p>This is based on the estimated resident population at 31 March 2025 and the following forecasts:</p>
    <ul>
      <li>one birth every 9 minutes and 1 second</li>
      <li>one death every 14 minutes and 46 seconds</li>
      <li>one net migration every 3 hours, 52 minutes and 9 seconds.</li>
    </ul>
    <p>The forecasts are based on recent trends and do not necessarily reflect actual population change.</p>
    <p>The population clock is based on the estimated resident population and does not correspond to the census usually resident population count or census night population count.</p>
    <p>The estimated resident population is derived from the 2023 Census usually resident population count, with adjustments for people missed or counted more than once by the census (net census undercount), residents temporarily overseas on census night, and population change since census night.</p>
    <p><strong>For the latest available data on population, births, deaths, and migration see:</strong></p>
    <ul>
      <li><strong>Estimates and projections</strong> – information about the current and future New Zealand population.</li>
      <li><strong>Population indicators</strong> – summary of New Zealand's key demographic statistics (population, births, deaths, marriages, migration etc).</li>
    </ul>
  </div>
</div>

<% require css('themes/your-theme/css/population-clock.css') %>
<% require javascript('themes/your-theme/javascript/population-clock.js') %>