import { mount } from '@vue/test-utils'
import sample from '@/pages/sample.vue'

describe('HelloWorld', () => {
  test('display Hello World', () => {
    const wrapper = mount(sample)
    expect(wrapper.text()).toBe("Hello World")
  })
})
