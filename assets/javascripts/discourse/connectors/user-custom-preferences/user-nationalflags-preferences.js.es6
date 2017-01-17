import 'discourse/models/store'
import files from './flaglist' //Terribly inefficient :(

export default {
  setupComponent(args, component) {
    component.set('natflaglist', files.files)
  }
};
