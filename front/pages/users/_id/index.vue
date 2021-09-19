<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-container>
      <v-row justify="space-around">
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
              {{ user.name }}
            </v-toolbar-title>
            <v-spacer />
            <v-btn
              icon
              large
            >
              <v-icon>mdi-dots-vertical</v-icon>
            </v-btn>
          </v-app-bar>
          <v-divider/>
          <v-img
            height="200px"
            width="1000px"
            :src="user.header"
          />
          <v-list-item class="grow">
            <v-list-item-avatar
              size=60
            >
              <v-img
                alt="user"
                contain
                :src="user.avatar"
              />
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title>
                {{ user.name }}
              </v-list-item-title>
            </v-list-item-content>
            <v-row
              align="center"
              justify="end"
              class="mr-1"
            >
              <template v-if="user.id != currentUserId">
                <v-tooltip bottom>
                  <template v-slot:activator="{ on }">
                    <v-btn
                      class="ma-2"
                      outlined
                      fab
                      small
                      color="blue"
                      v-on="on"
                      @click="toChatRoom(user.id)"
                    >
                      <v-icon>mdi-wechat</v-icon>
                    </v-btn>
                  </template>
                <span>チャットルーム</span>
              </v-tooltip>
                <div class="text-center">
                  <v-btn
                    min-width="130px"
                    v-if="follow"
                    rounded
                    :color="color"
                    @click="unfollowUser"
                    @mouseover="mouseover"
                    @mouseleave="mouseleave"
                  >
                    {{ message }}
                  </v-btn>
                  <v-btn
                    v-else
                    min-width="130px"
                    rounded
                    color="info"
                    outlined
                    dark
                    @click="followUser"
                  >
                    <v-icon class="mr-2">mdi-account-plus</v-icon>
                      フォロー
                  </v-btn>
                </div>
              </template>
              <template v-else>
                <div>
                  <user-edit
                    @fetchUser="fetchUser"
                  />
                </div>
              </template>
            </v-row>
          </v-list-item>
          <v-card-title>
            <div class="font-weight-bold ml-8 mb-2">
              {{ user.introduction}}
            </div>
          </v-card-title>
          <v-card-subtitle
            link
            @click="toFollowingUser(user.id)"
          >
          {{ following_user.length }}フォロー中
          </v-card-subtitle>
          <v-card-subtitle
            @click="toFollowerUser(user.id)"
          >
          {{ follower_user.length }}フォロワー
          </v-card-subtitle>
          <v-divider />
          <v-tabs
            v-model="tab"
            color="primary accent-10"
            grow
          >
            <v-tab>ツイート</v-tab>
            <v-tab>ツイートと返信</v-tab>
            <v-tab>メディア</v-tab>
            <v-tab>いいね</v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item>
              <div>
                <comment-card
                  v-for="comment in posts"
                  :key="comment.id"
                  :content-id="comment.id"
                  @fetchUser="fetchUser"
                />
              </div>
            </v-tab-item>
            <v-tab-item>
              <div>
                <div
                  v-for="comment in post_and_comments"
                  :key="comment.id"
                  :content-id="comment.id"
                >
                  <v-card
                  >
                    <comment-card
                      :content-id="comment.post.id"
                      @fetchUser="fetchUser"
                    />
                  </v-card>
                  <div class="d-flex">
                    <v-divider
                      vertical
                      inset
                      class="ml-9"
                    />
                    <div>
                      <div
                        class="pl-5"
                      >
                        <comment-card
                          :content-id="comment.comment.id"
                          @fetchUser="fetchUser"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </v-tab-item>
            <v-tab-item>
              <div>
                メディア
              </div>
            </v-tab-item>
            <v-tab-item>
              <div>
                <comment-card
                  v-for="comment in like_posts"
                  :key="comment.id"
                  :content-id="comment.id"
                  @fetchUser="fetchUser"
                />
              </div>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </v-row>
    </v-container>
  </layout-main>
</template>
<script>
import { mapGetters, mapActions } from 'vuex'
import layoutMain from '../../../components/layout/loggedIn/layoutMain.vue'
import commentCard from '../../../components/post/commentCard.vue'
import userEdit from '../../../components/user/userEdit.vue'
export default {
  components: {
    layoutMain,
    userEdit,
    commentCard
  },
  data () {
    return {
      tab: null,
      user: { id: '', name: '', email: '', avatar: '', introduction: '', admin: '', header: '' },
      posts: {},
      // medias: {},
      like_posts: {},
      color: 'blue white--text',
      message: 'フォロー中',
      follow: false,
      post_and_comments: [],
      following_user: [],
      follower_user: []
    }
  },
  computed: {
    ...mapGetters({
      btnColor: 'btn/color',
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated'
    })
  },
  mounted () {
    this.fetchUser()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    async fetchUser () {
      const url = `/api/v1/users/${this.$route.params.id}`
      await this.$axios.get(url)
        .then((res) => {
          this.user.id = res.data.user.id
          this.user.name = res.data.user.name
          this.user.email = res.data.user.email
          this.user.introduction = res.data.user.introduction
          this.user.avatar = res.data.user.avatar.url
          this.user.admin = res.data.user.admin
          this.user.header = res.data.user.header.url
          this.posts = res.data.posts
          this.like_posts = res.data.like_posts
          this.post_and_comments = res.data.post_and_comments
          this.following_user = res.data.following_user
          this.follower_user = res.data.follower_user
          if (this.user) {
            this.follow = false
            this.follower_user.forEach((v) => {
              if (v.id === this.currentUserId) {
                this.follow = true
              }
            })
          }
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    followUser () {
      this.$axios.post('/api/v1/relationships', {
        user_id: this.currentUserId,
        follow_id: this.user.id
      })
        .then((res) => {
          this.flashMessage({ message: 'フォローしました', type: 'success', status: true })
          this.$axios.get(`/api/v1/users/${this.$route.params.id}`)
            .then((res) => {
              this.follow = true
              console.log('フォロー後レス', res)
              this.follower_user = res.data.follower_user
            })
        })
        .catch((err) => {
          console.log('フォローエラー', err)
        })
    },
    unfollowUser () {
      this.$axios.delete('/api/v1/relationships/delete', {
        params: {
          user_id: this.currentUserId,
          follow_id: this.user.id
        }
      })
        .then((res) => {
          console.log('フォロー外しました')
          this.flashMessage({ message: 'フォロー解除しました', type: 'success', status: true })
          this.$axios.get(`/api/v1/users/${this.$route.params.id}`)
            .then(() => {
              this.follow = false
              this.follower_user = res.data.follower_user
            })
        })
    },
    mouseover () {
      this.color = 'red white--text'
      this.message = 'フォロー解除'
    },
    mouseleave () {
      this.color = 'blue white--text'
      this.message = 'フォロー中'
    },
    parentEvent () {
      this.$refs.userEdit.userDataSet()
    },
    toFollowingUser (id) {
      this.$router.push({ path: `/users/${id}/follow`, query: { tab: 0 } })
    },
    toFollowerUser (id) {
      this.$router.push({ path: `/users/${id}/follow`, query: { tab: 1 } })
    },
    pageBack () {
      this.$router.go(-1)
    },
    toChatRoom (id) {
      this.$router.push(`/rooms/${id}`)
    }
  }
}
</script>
