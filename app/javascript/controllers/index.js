import { application } from 'controllers/application'

// Eager load all controllers
import { eagerLoadControllersFrom } from '@hotwired/stimulus-loading'
eagerLoadControllersFrom('controllers', application)
