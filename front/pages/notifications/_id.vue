<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card>
      <v-app-bar
        flat
        color="rgba(0, 0, 0, 0)"
      >
        <v-btn
          icon
          large
          class="mr-5"
          @click="pageBack"
        >
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <v-toolbar-title>
          通知
        </v-toolbar-title>
      </v-app-bar>
      <v-divider />
      <v-row>
        <v-col>
          <v-card-text
            v-if="notifications==''"
          >
            通知はありません
          </v-card-text>
          <v-card
            v-for="notification in notifications"
            :key="notification.id"
            style="cursor: pointer;"
            class="mb-4"
          >
            <template v-if="notification.action === 'follow'">
              <follow-card
                :notification="notification"
                :user="notification.visitor"
              />
            </template>
            <template v-else-if="notification.action === 'chat'">
            </template>
            <template v-else>
              <like-comment-card
                :notification="notification"
                :user="notification.visitor"
                :post="notification.post"
              />
            </template>
          </v-card>
        </v-col>
      </v-row>
      <!-- <VueInfiniteLoading
        ref="infiniteLoading"
        spinner="bubbles"
        @infinite="infiniteHandler"
      >
        <span slot="no-more">-----投稿は以上です-----</span>
        <span slot="no-results">----投稿がありません----</span>
      </VueInfiniteLoading> -->
    </v-card>
  </layout-main>
</template>

<script>
import { mapGetters } from 'vuex'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
import LikeCommentCard from '../../components/notification/likeCommentCard.vue'
import FollowCard from '../../components/notification/folowCard.vue'
export default {
  components: {
    layoutMain,
    LikeCommentCard,
    FollowCard
  },
  async asyncData ({ $axios, params }) {
    const res = await $axios.get(`/api/v1/notifications/${params.id}`)
    return { notifications: res.data.notifications }
  },
  data () {
    return {
      pageCount: 1
      // notifications: {}
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data'
    })
  },
  // mounted () {
  //   this.fetchNotifications()
  // },
  methods: {
    // fetchNotifications () {
    //   const url = `/api/v1/notifications/${this.$route.params.id}`
    //   this.$axios.get(url)
    //     .then((res) => {
    //       this.notifications = res.data
    //     })
    //     .catch((err) => {
    //       // eslint-disable-next-line no-console
    //       console.error(err)
    //     })
    // },
    // infiniteHandler () {
    //   this.pageCount += 1
    //   this.$axios.get(`/api/v1/notifications/${this.$route.params.id}`, { params: { page: this.pageCount } })
    //     .then((res) => {
    //       const notifications = res.data
    //       setTimeout(() => {
    //         if (notifications.length !== 0) {
    //           this.notifications.push(...notifications)
    //           this.$refs.infiniteLoading.stateChanger.loaded()
    //         } else {
    //           this.$refs.infiniteLoading.stateChanger.complete()
    //         }
    //       }, 1000)
    //     })
    // },
    pageBack () {
      this.$router.go(-1)
    },
    pushContents (res) {
      this.notifications.push(...res.data.notifications)
    }
    // pageIncrement () {
    //   this.page++
    // }
  }
}
</script>
