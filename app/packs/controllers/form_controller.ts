import { Controller } from '@hotwired/stimulus'
import { enableElement } from '@rails/ujs'

class FormController extends Controller {
  readonly resetTargets!: Element[]
}
export default class extends (Controller as typeof FormController) {
  static targets = ['reset'];

  reset (): void {
    this.resetTargets.forEach((element) => {
      enableElement(element)
    })
  }
}
