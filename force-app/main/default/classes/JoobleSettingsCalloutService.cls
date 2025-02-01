public with sharing class JoobleSettingsCalloutService {

    /**
     * Invocable method that is triggered when Job Application Settings are updated within 
     *      the Job App Settings Aduster Flow
     * This enacts a one-time Jooble callout, immediately thereafter, to pull in data corresponding
     *      to the new settings.
     *
     * @param settingsIds List of Job Application Setting record IDs that were updated.
     *                    This will always contain one ID because the Flow updates only one setting at a time.
     */
    public JoobleSettingsCalloutService() {

    }
}