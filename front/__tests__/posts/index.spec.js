import { mount } from '@vue/test-utils'
import postsIndex from '@/pages/sample.vue'

describe('HelloWorld', () => {
  test('display Hello World', () => {
    const wrapper = mount(postsIndex)
    expect(wrapper.text()).toBe("Hello World")
  })
})
