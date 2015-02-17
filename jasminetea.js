require('coffee-script/register');
basename= require('path').basename(__filename,'.js');
module.exports= require('./'+basename+'.coffee');