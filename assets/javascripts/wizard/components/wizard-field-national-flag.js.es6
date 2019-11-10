import { default as computed, on } from 'ember-addons/ember-computed-decorators';
import { ajax } from 'wizard/lib/ajax';

export default Ember.Component.extend({
  layoutName: 'javascripts/wizard/templates/components/wizard-field-national-flag',
  context: Ember.computed.alias('wizard.id'),
  natflaglist: [],

  @on('init')
  setup() {
    ajax({
      url:  '/natflags/flags',
      type: 'GET'
    }).then((natflags) => {

      let localised_flags = [];
      localised_flags = natflags.flags.map (element => {
        return {  code: element.code, 
                  pic: element.pic, 
                  description: I18n.t(`flags.description.${element.code}`) }});

      this.set('natflaglist', localised_flags);
    })
  }
});