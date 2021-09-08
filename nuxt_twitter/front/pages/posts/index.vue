<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <new-post-index
      @fetchPosts="fetchPosts"
    />
    <v-card
      v-for="post in posts"
      :key="post.id"
      class="ma-1"
      hover
      outlined
      @click="toShowPost(post.id)"
    >
      <v-list-item class="grow">
        <v-list-item-avatar
          size=60
        >
          <v-img
            :src="post.user.avatar.url"
            contain
            @click.stop="toShowUser(post.user_id)"
          />
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>
            {{ post.user.name }}
          </v-list-item-title>
        </v-list-item-content>
        <v-row
          align="center"
          justify="end"
          class="mr-1"
        >
          <caption>
            <v-icon size="15">
              mdi-update
            </v-icon>
              {{ $my.format(post.created_at) }}
          </caption>
        </v-row>
      </v-list-item>
      <v-row>
        <v-col>
          <v-card-text >
            {{ post.content }}
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
import NewPostIndex from '../../components/post/newPostIndex.vue'
import LayoutMain from '~/components/layout/loggedIn/layoutMain.vue'

export default {
  components: {
    LayoutMain,
    BtnDeletePost,
    LikePost,
    BtnEditPost,
    NewPostIndex
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
              this.posts.push(...posts)
              this.$refs.infiniteLoading.stateChanger.loaded()
            } else {
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
    }
  }
}
</script>
