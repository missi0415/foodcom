<template>
  <div
    v-show="hideStatus"
  >
    <v-card
      class="mb-1"
      hover
      outlined
      @click="toShowPost(post.id)"
    >
      <v-list-item
        class="grow"
      >
        <v-list-item-avatar
          size=50
        >
          <v-img
            :src="avatarImage"
            class="img"
            contain
            lazy-src
            @click.prevent.stop="toShowUser(post.user_id)"
          />
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>
            <nuxt-link
              class="pl-2"
              :to="'/users/' + post.user_id"
            >
              {{ post.user.name }}
            </nuxt-link>
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
              {{ time }}
          </caption>
        </v-row>
      </v-list-item>
      <v-row>
        <v-col>
          <v-card-text>
            <text-highlight :queries="keyword">
              {{ post.content}}
            </text-highlight>
          </v-card-text>
          <v-img
            :src="postImage"
            max-height="200"
            max-width="200"
            contain
          />
        </v-col>
      </v-row>
      <v-card-actions class="justify-space-around">
        <btn-new-comment
            :avatarImage="avatarImage"
            :post="post"
            :is-index="isIndex"
            @fetchComment="fetchPost"
          />
          <like-post
            :post="post"
            :like-posts="likePosts"
            :like-post-count="likeCount"
            @likeCountIncrement="likeCountIncrement"
            @likeCountDecrement="likeCountDecrement"
          />
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
            @hidePost="hidePost"
          />
        </template>
      </v-card-actions>
    </v-card>
    <template
      v-if="isUserCommentPage"
    >
      <nuxt-link
        class="ml-10 pl-8"
        :to="'/users/' + post.user_id"
      >
        {{ post.user.name }}
      </nuxt-link>
      さんへ返信
    </template>
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
    },
    isUserCommentPage: {
      type: Boolean
    },
    keyword: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      isIndex: true,
      src: 'https://picsum.photos/500/500',
      post: { user: {}, comments: {}, commentCount: 0 },
      comments: [],
      likePosts: [],
      commentCount: 0,
      likeCount: 0,
      time: '',
      loginUser: {},
      postImage: '',
      avatarImage: '',
      hideStatus: 'true'
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
      await this.$axios.get(url)
        .then((res) => {
          console.log('then.res', res)
          this.avatarImage = res.data.user.avatar.url
          this.post = res.data.post
          this.time = this.$my.format(res.data.post.created_at)
          this.postImage = res.data.post.image.url
          this.post.user = res.data.user
          this.post.comments = res.data.comments
          this.likePosts = res.data.like_posts
          this.likeCount = res.data.like_posts.length
          this.post.commentCount = res.data.comment_count
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
    hidePost () {
      console.log('hidepost-commentcard')
      this.hideStatus = false
    },
    fetchUser () {
      this.$emit('fetchUser')
    }
  }
}
</script>
<style scoped>
.btn-repeat:hover {
  color: #02b97c;
  }
.img:hover {
  opacity: 0.7;
}

</style>
