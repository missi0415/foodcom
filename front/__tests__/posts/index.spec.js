import { mount } from '@vue/test-utils'
import postIndex from '@/pages/posts/index.vue'

describe('PostIndex', () => {
  test('テスト１', () => {
    const wrapper = mount(postIndex)
    expect(wrapper.text()).toBe("いまなにしてる？")
  })
})
