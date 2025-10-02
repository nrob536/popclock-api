# SilverStripe Population Clock Integration

This folder contains all the files needed to integrate the New Zealand Population Clock into a SilverStripe CMS website.

## Files Included

### 1. Elemental Content Block (Recommended)
- `PopulationClockElement.php` - Content block class for SilverStripe Elemental
- `PopulationClockElement.ss` - Template for the elemental block
- `population-clock.css` - Stylesheet
- `population-clock.js` - JavaScript functionality

### 2. Simple Include Template
- `PopulationClockInclude.ss` - Simple template that can be included anywhere

## Installation Options

### Option 1: Elemental Content Block (Recommended)

1. **Install SilverStripe Elemental** (if not already installed):
   ```bash
   composer require dnadesign/silverstripe-elemental
   ```

2. **Add the element class** to your project:
   - Copy `PopulationClockElement.php` to `app/src/Elements/`
   - Copy `PopulationClockElement.ss` to `themes/your-theme/templates/DNADesign/Elemental/Layout/`

3. **Add CSS and JS assets**:
   - Copy `population-clock.css` to `themes/your-theme/css/` or your CSS build process
   - Copy `population-clock.js` to `themes/your-theme/javascript/` or your JS build process

4. **Run dev/build** to create the database table:
   ```bash
   sake dev/build flush=1
   ```

5. **Add to your page types** in the CMS by adding an ElementalArea to your page class:
   ```php
   use DNADesign\Elemental\Extensions\ElementalPageExtension;
   
   class Page extends SiteTree
   {
       private static $extensions = [
           ElementalPageExtension::class,
       ];
   }
   ```

### Option 2: Simple Template Include

1. **Copy the include template**:
   - Copy `PopulationClockInclude.ss` to `themes/your-theme/templates/Includes/`

2. **Add CSS and JS assets** (same as above)

3. **Include in your templates**:
   ```html
   <% include PopulationClockInclude %>
   ```

### Option 3: Direct Widget Integration

Use the standalone `popclock-widget.html` file and embed it as an iframe or copy the content directly into your templates.

## Configuration

### API Endpoint
The default API endpoint is: `https://popclock-api.onrender.com/clock/estimate?format=json`

You can change this in:
- Elemental block: Through the CMS interface
- Include template: Edit the `data-api-url` attribute
- Widget: Edit the `API_URL` constant

### Styling
The CSS is scoped to avoid conflicts with your existing styles. You can customize the appearance by:
- Modifying the CSS variables at the top of `population-clock.css`
- Adding your own CSS rules with higher specificity
- Integrating with your existing design system

### Features
- **Real-time updates**: Population estimates update every 21 minutes and 2 seconds
- **Responsive design**: Works on desktop, tablet, and mobile
- **Multiple instances**: Can have multiple clocks on the same page
- **Error handling**: Graceful fallback when API is unavailable
- **CMS control**: Elemental version allows content editors to configure options

## Browser Support
- Modern browsers (Chrome, Firefox, Safari, Edge)
- IE11+ (with polyfills for fetch API if needed)
- Mobile browsers

## Dependencies
- SilverStripe 4.x or 5.x
- SilverStripe Elemental (for the content block option)
- Modern browser with JavaScript enabled