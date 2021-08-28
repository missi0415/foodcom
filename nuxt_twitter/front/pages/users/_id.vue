<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    page users/id.vue
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
              class="pr-5"
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
          <v-img
            height="200px"
            src="https://cdn.pixabay.com/photo/2020/07/12/07/47/bee-5396362_1280.jpg"
          />
          <v-card-title>
            <v-avatar size="56">
              <img
                alt="user"
                src="https://cdn.pixabay.com/photo/2020/06/24/19/12/cabbage-5337431_1280.jpg"
              >
            </v-avatar>
            <p class="ml-3 mt-3">
              {{ user.name }}
            </p>
            <v-spacer />
            <div class="text-center">
              {{ currentUser }}
              {{ user }}
              {{ isAuthenticated }}
              <v-btn
                rounded
                color="info"
                @click="unfollowUser"
                @mouseover="mouseover"
                @mouseleave="mouseleave"
              >
              フォローを外す
                {{ message }}
              </v-btn>
              <v-btn
                rounded
                color="info"
                outlined
                dark
                @click="followUser"
              >
              フォローボタン
              </v-btn>
            </div>
          </v-card-title>
          <v-card-title>
            <div class="font-weight-bold ml-8 mb-2">
              よろしくおねがいします
            </div>
          </v-card-title>
          <v-divider />
          <v-tabs
            v-model="tab"
            color="primary accent-10"
            grow
          >
            <v-tab>ツイート</v-tab>
            <v-tab>コメント</v-tab>
            <v-tab>メディア</v-tab>
            <v-tab>いいね</v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item>
              <div v-for="post in posts" :key="post.id">
                <show-card
                  :is-post="true"
                  :user="post.user"
                  :content-id="post.id"
                  :content="post.content"
                />
              </div>
            </v-tab-item>
            <v-tab-item>
              <div v-for="comment in comments" :key="comment.id">
                <show-card
                  :is-post="false"
                  :user="comment.user"
                  :content-id="comment.id"
                  :content="comment.content"
                />
              </div>
            </v-tab-item>
            <v-tab-item>
              <div>
                メディア
              </div>
            </v-tab-item>
            <v-tab-item>
              <div
                v-for="like_post in like_posts"
                :key="like_post.id"
              >
                <show-card
                  :is-post="true"
                  :user="like_post.user"
                  :content-id="like_post.post.id"
                  :content="like_post.post.content"
                />
              </div>
              <div
                v-for="like_comment in like_comments"
                :key="like_comment.id"
              >
                <show-card
                  :is-post="false"
                  :user="like_comment.user"
                  :content-id="like_comment.comment.id"
                  :content="like_comment.comment.content"
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
import ShowCard from '../../components/user/showCard.vue'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
export default {
  components: {
    ShowCard,
    layoutMain
  },
  data () {
    return {
      tab: null,
      user: {},
      posts: {},
      comments: {},
      // medias: {},
      like_posts: {},
      like_comments: {},
      like_content: {},
      message: 'フォロー中',
      fallow: false
    }
  },
  computed: {
    ...mapGetters({
      btnColor: 'btn/color',
      currentUser: 'auth/data',
      isAuthenticated: 'auth/isAuthenticated'
    })
  },
  created () {
    this.getShowUserData()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    async getShowUserData () {
      const url = `/api/v1/users/${this.$route.params.id}`
      await this.$axios.get(url)
        .then((res) => {
          console.log(res.data)
          this.user.id = res.data.id
          this.user.name = res.data.name
          this.posts = res.data.posts
          this.comments = res.data.comments
          this.like_posts = res.data.like_posts
          this.like_comments = res.data.like_comments
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    followUser () {
      console.log(this.currentUser.id, this.user.id)
      this.$axios.post('/api/v1/relationships', {
        user_id: this.currentUser.id,
        follow_id: this.user.id
      })
        .then((res) => {
          console.log('フォローしました', res)
          this.flashMessage({ message: 'フォローしました', type: 'success', status: true })
          this.$axios.get(`/api/v1/users/${this.$route.params.id}`)
            .then((res) => {
              console.log('フォロー後レス', res)
              this.follow = true
              this.followers = res.data.followers
            })
        })
        .catch((err) => {
          console.log('フォローエラー', err)
        })
    },
    unfollowUser () {
      this.$axios.delete('/api/v1/relationships/delete', {
        params: {
          user_id: this.currentUser.id,
          follow_id: this.user.id
        }
      })
        .then((res) => {
          console.log('フォロー外しました')
          this.showMessage({ message: 'フォロー解除しました', type: 'success', status: true })
          this.$axios.get(`/api/v1/users/${this.$route.params.id}`)
            .then(() => {
              this.follow = false
              this.followers = res.data.followers
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
    }
  }
}
</script>
