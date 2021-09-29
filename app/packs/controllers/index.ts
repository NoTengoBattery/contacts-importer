// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from '@hotwired/stimulus'
import { definitionsFromContext } from '@hotwired/stimulus-webpack-helpers'

declare global {
    interface Window { Stimulus: Application; }
}

const Stimulus = window.Stimulus = Application.start()
const context = require.context('controllers', true, /_controller\.[jt]s$/)
Stimulus.load(definitionsFromContext(context))
