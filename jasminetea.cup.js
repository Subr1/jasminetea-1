var jasminetea;
// Avoid conflicts with another version
if(typeof require('module')._extensions['.coffee']==='undefined'){
  require('coffee-script/register');
}
jasminetea= require('./jasminetea.coffee');

// d_| dripped

module.exports= jasminetea;