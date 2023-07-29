import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

const application = Application.start();
const controllers = require.context('.', true, /\.js$/);
application.load(definitionsFromContext(controllers));
