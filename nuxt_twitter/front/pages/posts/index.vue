<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-card
      v-for="post in posts"
      :key="post.id"
      class="ma-1"
      hover
      outlined
      @click="toShow(post.id)"
    >
    <v-card-text>
      page posts/index.vue
    </v-card-text>
      <v-row>
        <v-col class="d-flex">
          <v-img
            :src="src"
            max-height="60"
            max-width="60"
            contain
            class="ml-2"
            style="border-radius: 50%"
            @click.prevent.stop="toShowUser(post.user_id)"
          />
          <v-card-text>
            {{ post.user.id }}
            {{ post.user.name }}
          </v-card-text>
          <v-card-text
            class="text-right"
          >
            <v-icon size="16">
              mdi-update
            </v-icon>
            {{ $my.format(post.created_at) }}
          </v-card-text>
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <v-card-title
            class="card-content"
          >
            {{ post.content }}
          </v-card-title>
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
                :user="post.user"
                :comments="post.comments"
                :is-index="isIndex"
              />
              <template v-if="post.user_id !== currentUser.id">
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
              <template v-if="post.user_id === currentUser.id">
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
  </layout-main>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import LikePost from '../../components/btn/likePost.vue'
import BtnEditPost from '../../components/btn/btnEditPost.vue'
import BtnDeletePost from '../../components/btn/btnDeletePost.vue'
import BtnNewComment from '~/components/btn/btnNewcomment.vue'
import LayoutMain from '~/components/layout/loggedIn/layoutMain.vue'

export default {
  components: { LayoutMain, BtnDeletePost, BtnNewComment, LikePost, BtnEditPost },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: true,
      posts: []
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
    this.fetchPosts()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
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
    toshowUser (id) {
      this.$router.push(`/users/${id}`)
    }
  }
}
</script>
