import 'discourse/models/store'
import { ajax } from 'discourse/lib/ajax';

export default {
  setupComponent(args, component) {
  ajax('/natflags/flags').then((natflags) => {

      let localised_flags = [];
      localised_flags = natflags.flags.map (element => {
        return {  code: element.code, 
                  pic: element.pic, 
                  description: I18n.t(`flags.description.${element.code}`) }});

      component.set('natflaglist', localised_flags);
  } )
  }
};
