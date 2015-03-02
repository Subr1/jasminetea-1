var basename= require('path').basename(__filename,'.js');

require('coffee-script/register');
module.exports= require('./'+basename+'.coffee');