<template>
  <div>
    <v-card
      class="ma-1"
      hover
      outlined
      @click="toShowPost(post.id)"
    >
      <v-list-item
        class="grow"
        link
      >
        <v-list-item-avatar
          size=60
        >
          <v-img
            :src="avatarImage"
            contain
            lazy-src
            @click.prevent.stop="toShowUser(post.user_id)"
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
              {{ time }}
          </caption>
        </v-row>
      </v-list-item>
      <v-row>
        <v-col>
          <v-card-text>
            {{ post.content}}
          </v-card-text>
          <v-img
            :src="postImage"
            max-height="200"
            max-width="200"
            contain
          />
        </v-col>
      </v-row>
      <v-divider />
      <v-card-actions class="justify-space-around">
        <btn-new-comment
            :post="post"
            :is-index="isIndex"
            @fetchComment="fetchPost"
          />
        <template v-if="post.user_id !== currentUserId">
            <v-btn
              icon
              class="btn-repeat"
            >
              <v-icon>mdi-repeat-variant</v-icon>
            </v-btn>
          </template>
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
      postImage: '',
      avatarImage: ''
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
          this.avatarImage = res.data.user.avatar.url
          this.post = res.data.post
          this.time = this.$my.format(res.data.post.created_at)
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
<style scoped>
a {
  position: relative;
  display: inline-block;
  text-decoration: none;
}
a::after {
  position: absolute;
  bottom: -4px;
  left: 0;
  content: '';
  width: 100%;
  height: 2px;
  background: #333;
  transform: scale(0, 1);
  transform-origin: left top;
  transition: transform .3s;
}
a:hover::after {
  transform: scale(1, 1);
}
.btn-repeat:hover {
    color: green;
  }

</style>
