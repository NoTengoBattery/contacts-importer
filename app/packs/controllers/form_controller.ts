import { Controller } from '@hotwired/stimulus'
import { enableElement } from '@rails/ujs'

export default class extends Controller {
  readonly resetTarget!: Element
  readonly resetTargets!: Element[]
  readonly hasResetTarget!: boolean

  static targets = ['reset'];

  reset (): void {
    this.resetTargets.forEach((element) => {
      enableElement(element)
    })
  }
}
