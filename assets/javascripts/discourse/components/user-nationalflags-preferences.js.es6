import 'discourse/models/store'
import { default as computed, on } from 'ember-addons/ember-computed-decorators';
import { ajax } from 'discourse/lib/ajax';

// export default {
//   setupComponent(args, component) {
//   ajax('/natflags/flags').then((natflags) => {

//       let localised_flags = [];
//       localised_flags = natflags.flags.map (element => {
//         return {  code: element.code, 
//                   pic: element.pic, 
//                   description: I18n.t(`flags.description.${element.code}`) }});

//       component.set('natflaglist', localised_flags);
//   } )
//   }
// };

export default Ember.Component.extend({
  layoutName: 'javascripts/discourse/templates/connectors/user-custom-preferences/user-nationalflags-preferences',
  natflaglist: [],

  @on('init')
  setup() {
    console.log ('here');
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
  },

  @computed('model.custom_fields.nationalflag_iso')
  flagsource() {
    return  (this.get('model.custom_fields.nationalflag_iso')==null) ? 'none' : this.get('model.custom_fields.nationalflag_iso')
  }
});
