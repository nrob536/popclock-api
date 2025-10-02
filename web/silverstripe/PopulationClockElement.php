<?php

namespace App\Elements;

use DNADesign\Elemental\Models\BaseElement;
use SilverStripe\Forms\FieldList;
use SilverStripe\Forms\CheckboxField;
use SilverStripe\Forms\TextField;

/**
 * Population Clock Element for SilverStripe Elemental
 * 
 * This creates a content block that can be added to pages
 * through the CMS interface.
 */
class PopulationClockElement extends BaseElement
{
    private static $table_name = 'PopulationClockElement';
    
    private static $singular_name = 'Population Clock';
    private static $plural_name = 'Population Clocks';
    private static $description = 'Display New Zealand population statistics in real-time';
    
    private static $db = [
        'ShowCaveat' => 'Boolean',
        'APIEndpoint' => 'Varchar(255)',
        'Title' => 'Varchar(255)'
    ];
    
    private static $defaults = [
        'ShowCaveat' => true,
        'APIEndpoint' => 'https://popclock-api.onrender.com/clock/estimate?format=json',
        'Title' => 'New Zealand Population Clock'
    ];

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        
        $fields->addFieldsToTab('Root.Main', [
            TextField::create('Title', 'Widget Title')
                ->setDescription('Optional title to display above the clock'),
            TextField::create('APIEndpoint', 'API Endpoint')
                ->setDescription('URL to the population clock API'),
            CheckboxField::create('ShowCaveat', 'Show Information Caveat')
                ->setDescription('Display detailed information about the population statistics')
        ]);
        
        return $fields;
    }

    public function getType()
    {
        return 'Population Clock';
    }
    
    public function getSummary()
    {
        return 'Real-time New Zealand population statistics display';
    }
}