'use strict';

/**
 * uni service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::uni.uni');
