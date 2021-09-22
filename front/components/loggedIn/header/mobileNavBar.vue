<template>
  <v-bottom-navigation
    v-show="$vuetify.breakpoint.xs"
    v-model="setDrawer"
    app
    clipped
    bottom
    color="primary"
    grow
  >
      <v-btn
        @click="goHome"
      >
        <v-icon
          size="38px"
        >
          mdi-home
        </v-icon>
      </v-btn>
      <v-btn
        @click="toSearches"
      >
        <v-icon
          size="38px"
        >
          mdi-magnify
        </v-icon>
      </v-btn>
      <v-btn
        @click="toNotificatons"
      >
        <v-badge
          color="red"
          :content="noticeCount"
          :value="noticeCount"
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-bell-outline
          </v-icon>
        </v-badge>
      </v-btn>
      <!-- <v-btn
        link
      >
        <v-icon
          size="38px"
          class="justify-center"
        >
          mdi-chat-processing-outline
        </v-icon>
      </v-btn> -->
      <v-btn
        link
        class="pa-1 justify-center"
        @click="toFollowingUser"
      >
        <v-icon
          size="38px"
          class="justify-center"
        >
          mdi-account-details
        </v-icon>
      </v-btn>
      <!-- <v-btn
        link
        class="pa-1 justify-center"
        @click="toFollowerUser"
      >
          <v-icon
            size="38px"
            class="justify-center"
          >
            mdi-account-details-outline
          </v-icon>
      </v-btn> -->
  </v-bottom-navigation>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  props: {
    drawer: {
      type: Boolean,
      default: null
    }
  },
  data () {
    return {
      mini: false,
      count: 0,
      noticeCount: 0
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
  watch: {
    isActive (val) {
      if (val) {
        this.fetchContents()
        this.setIsActive(false)
      }
    }
  },
  mounted () {
    setTimeout(() => {
      this.fetchNotificationCount()
    }, 500)
  },
  methods: {
    ...mapActions({
      setPosts: 'post/setPosts'
    }),
    async goHome () {
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
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
    },
    toNotificatons () {
      this.$router.push(`/notifications/${this.currentUserId}`)
      this.noticeCount = 0
    },
    toSearches () {
      this.$router.push('/searches')
    },
    fetchNotificationCount () {
      const url = `api/v1/find_notifications_count/${this.currentUserId}`
      this.$axios.get(url)
        .then((res) => {
          this.noticeCount = res.data
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}
</script>
