<template>
  <v-navigation-drawer
    v-model="setDrawer"
    app
    clipped
    :mini-variant="$vuetify.breakpoint.md || $vuetify.breakpoint.sm || $vuetify.breakpoint.xs"
    mini-variant-width="112"
    mobile-breakpoint="0"
    bottom
    class="pa-3 justify-center"
  >
  <!-- {{ $vuetify.breakpoint.md }} -->
    <v-list
      rounded
    >
      <v-list-item
        link
        class="pa-1 justify-center"
        @click="goHome"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-home
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>
            ホーム
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        link
        class="pa-1 justify-center"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-magnify
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>
            検索
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        link
        class="pa-1 justify-center"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-bell-outline
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>
            通知
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        link
        class="pa-1 justify-center"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-chat-processing-outline
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>
            メッセージ
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        link
        class="pa-1 justify-center"
        @click="toFollowingUser"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-account-details
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>
            フォロー
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        link
        class="pa-1 justify-center"
        @click="toFollowerUser"
      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-account-details-outline
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>
            フォロワー
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <new-post />
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import NewPost from '../../post/newPost.vue'
export default {
  components: {
    NewPost
  },
  props: {
    drawer: {
      type: Boolean,
      default: null
    }
  },
  data () {
    return {
      mini: false
    }
  },
  computed: {
    ...mapGetters({
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated'
    }),
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
    },
    toFollowingUser () {
      this.$router.push({ path: `/users/${this.currentUserId}/follow`, query: { tab: 0 } })
    },
    toFollowerUser () {
      this.$router.push({ path: `/users/${this.currentUserId}/follow`, query: { tab: 1 } })
    }
  }
}
</script>
