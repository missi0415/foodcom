<template>
  <v-navigation-drawer
    v-model="setDrawer"
    app
    clipped
    :mini-variant="$vuetify.breakpoint.md || $vuetify.breakpoint.sm || $vuetify.breakpoint.xs"
    mini-variant-width="112"
    mobile-breakpoint="0"
    class="pa-3 justify-center"
  >
  <!-- {{ $vuetify.breakpoint.md }} -->
    <v-list
      rounded
    >
      <v-list-item
        v-for="item in items"
        :key="item.title"
        link
        class="pa-1 justify-center"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
          {{ item.icon }}
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <new-post />
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { mapActions } from 'vuex'
import newPost from '../../post/newPost.vue'
export default {
  components: {
    newPost
  },
  props: {
    drawer: {
      type: Boolean,
      default: null
    }
  },
  data () {
    return {
      mini: false,
      items: [
        { title: 'ホーム', icon: 'mdi-home', clickLink: 'goHome' },
        { title: '検索', icon: 'mdi-magnify', clickLink: 'goHome' },
        { title: '通知', icon: 'mdi-bell-outline', clickLink: 'goHome' },
        { title: 'メッセージ', icon: 'mdi-chat-processing-outline', clickLink: 'goHome' },
        { title: 'フォロー', icon: 'mdi-account-details', clickLink: 'goHome' },
        { title: 'フォロワー', icon: 'mdi-account-details-outline', clickLink: 'goHome' }
      ]
    }
  },
  computed: {
    setDrawer: {
      get () { return this.drawer },
      set (val) { return this.$emit('update:drawer', val) }
    }
  },
  methods: {
    ...mapActions({
      setPosts: 'post/setPosts'
    }),
    async goHome () {
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
          this.setPosts(res.data)
          this.$router.push('/posts')
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}
</script>
