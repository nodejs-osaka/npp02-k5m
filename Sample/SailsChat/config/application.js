/**
 * Production settings
 *
 *
 *
 * For more information, check out:
 * http://sailsjs.org/#documentation
 */

module.exports = {

  appName: "Sails Application",

  port: process.env.PORT || 1337,

  environment: process.env.NODE_ENV || 'production',

  facebook: {
    appId: "111111"
  }
};