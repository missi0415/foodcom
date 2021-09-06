<template>
  <div>
    <v-card
      outlined
      elevation="15"
      @click="toShowPost(post.id)"
    >
      <v-row>
        <v-col class="d-flex">
          <v-img
            :src="src"
            max-height="70"
            max-width="70"
            style="border-radius: 50%;"
            contain
            class="ml-3 mt-3"
            @click.prevent.stop="toShowUser(post.user_id)"
          />
          <v-card-title>
            {{ post.user.name }}
          </v-card-title>
        </v-col>
      </v-row>
      <v-card-text>
        {{ post.content }}
      </v-card-text>
      <v-img
        :src="postImage"
        max-height="200"
        max-width="200"
        contain
      />
      <v-divider />
      <v-card-actions class="justify-space-around">
        <btn-new-comment
            :post="post"
            :is-index="isIndex"
            @fetchComment="fetchPost"
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
            :like-posts="likePosts"
            :like-post-count="likeCount"
            @likeCountIncrement="likeCountIncrement"
            @likeCountDecrement="likeCountDecrement"
          />
        <template v-if="post.user_id !== currentUserId">
          <v-btn
            :color="btnColor"
            text
          >
            <v-icon v-text="'mdi-twitter-retweet'" />
          </v-btn>
        </template>
        <template v-if="post.user_id === currentUserId">
          <btn-edit-post
            :post="post"
            :is-index="isIndex"
            @fetchComment="fetchComment"
          />
          <btn-delete-post
            :post="post"
            :is-index="isIndex"
            @fetchPost="fetchPost"
          />
        </template>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import BtnDeletePost from '../btn/btnDeletePost.vue'
import BtnEditPost from '../btn/btnEditPost.vue'
import BtnNewComment from '../btn/btnNewComment.vue'
import LikePost from '../btn/likePost.vue'
export default {
  components: {
    LikePost,
    BtnNewComment,
    BtnEditPost,
    BtnDeletePost
  },
  props: {
    contentId: {
      type: Number,
      required: true
    }
  },
  data () {
    return {
      isIndex: true,
      src: 'https://picsum.photos/500/500',
      post: { user: {}, comments: {} },
      comments: [],
      likePosts: [],
      commentsCount: 0,
      likeCount: 0,
      time: '',
      loginUser: {},
      postImage: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      isAuthenticated: 'auth/isAuthenticated',
      currentUserId: 'auth/currentUserId',
      btnColor: 'btn/color'
    })
  },
  mounted () {
    this.fetchComment()
  },
  methods: {
    toShowComment (id) {
      this.$router.push(`/comments/${id}`)
    },
    async fetchComment () {
      const url = `/api/v1/posts/${this.contentId}`
      console.log('fetchComment')
      await this.$axios.get(url)
        .then((res) => {
          console.log('then.res', res)
          this.post = res.data.post
          this.postImage = res.data.post.image.url
          this.post.user = res.data.user
          this.post.comments = res.data.comments
          this.commentsCount = res.data.comments.length
          this.likePosts = res.data.like_posts
          this.likeCount = res.data.like_posts.length
          this.time = this.$my.format(this.post.created_at)
        })
    },
    likeCountIncrement () {
      this.likeCount++
    },
    likeCountDecrement () {
      this.likeCount--
    },
    toShowPost (id) {
      this.$router.push(`/posts/${id}`)
    },
    toShowUser (id) {
      this.$router.push(`/users/${id}`)
    },
    fetchPost () {
      this.$emit('fetchPost')
    },
    fetchUser () {
      this.$emit('fetchUser')
    }
  }
}
</script>
