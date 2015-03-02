var basename= require('path').basename(__filename,'.pomace.js');

require('coffee-script/register');
module.exports= require('./'+basename+'.coffee');