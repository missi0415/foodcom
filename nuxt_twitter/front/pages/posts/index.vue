<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-card
      v-for="post in posts"
      :key="post.id"
      class="ma-1"
      hover
      outlined
      @click="toShowPost(post.id)"
    >
      <v-card-title>
        <v-avatar size="56">
          <img
            :src="src"
            contain
            @click.stop="toShowUser(post.user_id)"
          />
          </v-avatar>
          <p class="ml-3 mt-3">
              {{ post.user.name }}
          </p>
          <v-spacer />
          <p
            class="font-size: 1px"
          >
            <v-icon size="15">
              mdi-update
            </v-icon>
            {{ $my.format(post.created_at) }}
          </p>
      </v-card-title>
      <v-row>
        <v-col>
          <v-card-text >
            {{ post }}
          </v-card-text>
          <v-img
            :src="post.image.url"
            max-height="200"
            max-width="200"
            contain
          />
        </v-col>
      </v-row>
      <template v-if="isAuthenticated">
        <v-row>
          <v-col>
            <v-card-actions class="justify-space-around">
              <btn-new-comment
                :post="post"
                :is-index="isIndex"
              />
              <template v-if="post.user_id !== currentUserId">
                <v-btn
                  :color="btnColor"
                  text
                >
                  <v-icon v-text="'mdi-twitter-retweet'" />
                </v-btn>
              </template>
              <like-post
                :post="post"
                :like-posts="post.like_posts"
                :like-post-count="post.like_posts.length"
              />
              <template v-if="post.user_id === currentUserId">
                <btn-edit-post
                  :post="post"
                  :is-index="isIndex"
                  @fetchPosts="fetchPosts"
                />
                <btn-delete-post
                  :post="post"
                  :is-index="isIndex"
                  @fetchPosts="fetchPosts"
                />
              </template>
            </v-card-actions>
          </v-col>
        </v-row>
      </template>
    </v-card>
    <VueInfiniteLoading
      ref="infiniteLoading"
      spinner="bubbles"
      @infinite="infiniteHandler"
    >
      <span slot="no-more">-----投稿は以上です-----</span>
      <span slot="no-results">----投稿がありません----</span>
    </VueInfiniteLoading>
  </layout-main>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import LikePost from '../../components/btn/likePost.vue'
import BtnEditPost from '../../components/btn/btnEditPost.vue'
import BtnDeletePost from '../../components/btn/btnDeletePost.vue'
// import BtnNewComment from '~/components/btn/btnNewComment.vue'
import LayoutMain from '~/components/layout/loggedIn/layoutMain.vue'

export default {
  components: {
    LayoutMain,
    BtnDeletePost,
    // BtnNewComment,
    LikePost,
    BtnEditPost
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: true,
      posts: [],
      count: 1
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
  created () {
    this.fetchPosts()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    infiniteHandler () {
      this.count += 1
      this.$axios.get('/api/v1/posts', { params: { page: this.count } })
        .then((res) => {
          const posts = res.data
          setTimeout(() => {
            if (posts.length !== 0) {
              console.log('ロードします', posts)
              this.posts.push(...posts)
              this.$refs.infiniteLoading.stateChanger.loaded()
            } else {
              console.log('データなし')
              this.$refs.infiniteLoading.stateChanger.complete()
            }
          }, 1000)
        })
    },
    async fetchPosts () {
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
          this.posts = res.data
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    toShowPost (id) {
      this.$router.push(`/posts/${id}`)
    },
    toShowUser (id) {
      this.$router.push(`/users/${id}`)
    },
    async fetch () {
      const url = '/api/v1/posts'
      await this.fetch(this.$axios.get(url))
        .then((res) => {
          this.posts = res.data
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}
</script>
