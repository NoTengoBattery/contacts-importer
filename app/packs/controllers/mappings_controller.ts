import { Controller } from '@hotwired/stimulus'

class MappingsController extends Controller {
  readonly selectTarget!: HTMLSelectElement
  readonly selectTargets!: HTMLSelectElement[]
}
export default class extends (Controller as typeof MappingsController) {
  static targets = ['select']

  select (): void {
    const statuses: {[key:string]: Array<boolean>} = {}
    this.selectTargets.forEach((selected) => {
      this.selectTargets.forEach((tested) => {
        if (selected === tested) return
        const index = selected.selectedIndex; const length = tested.length
        const statusArray = statuses[tested.id] = statuses[tested.id] || Array(tested.length)
        for (let i = 1; i < length; i++) {
          const cummulativeStatus = statusArray[i] = statusArray[i] || false
          tested.item(i)!.disabled = statusArray[i] = ((index === i) || cummulativeStatus)
        }
      })
    })
  }
}
