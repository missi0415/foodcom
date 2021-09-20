<template>
  <div>
    <v-tooltip bottom>
      <template #activator="{ on, attrs }">
        <v-btn
          icon
          class="pl-1 btn-comment"
          v-bind="attrs"
          v-on="on"
          @click.prevent.stop="dialog = true"
        >
          <v-icon v-text="'mdi-chat-processing-outline'" />
          &nbsp;
        </v-btn>
      </template>
      <span>返信</span>
    </v-tooltip>
    <template v-if="commentCount > 0">
      {{ commentCount }}
    </template>
    <v-dialog
      v-model="dialog"
      width="600"
    >
      <v-card class="pa-2">
        <div class="d-flex">
          <v-spacer />
          <v-btn
            icon
            @click="dialog = false"
          >
            ✖︎
          </v-btn>
        </div>
        <div class="d-flex">
          <v-img
            :src="avatarImage"
            max-height="60"
            max-width="60"
            contain
            style="border-radius: 50%;"
            class="ml-2"
          />
          <v-card-title>
            {{ post.user.name }}
          </v-card-title>
        </div>
        <div class="d-flex">
          <v-divider
            vertical
            inset
            class="ml-9"
          />
          <div>
            <v-card-subtitle>
              {{ post.content }}
            </v-card-subtitle>
            <v-spacer />
            <v-card-text>
              返信先：{{ post.user.name }} さん
            </v-card-text>
          </div>
        </div>
        <v-container>
          <v-form
            ref="form"
            v-model="isValid"
          >
            <new-post-form
              :content.sync="newPost.content"
            />
            <v-btn
              :disabled="!isValid || loading"
              :loading="loading"
              block
              color="info"
              @click="submitComment"
            >
              投稿する
            </v-btn>
          </v-form>
        </v-container>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import NewPostForm from '../post/newPostForm.vue'

export default {
  components: {
    NewPostForm
  },
  props: {
    post: {
      type: Object,
      required: true
    },
    isIndex: {
      type: Boolean,
      required: true
    },
    avatarImage: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      commentCount: 0,
      newPost: { content: '' },
      src: 'https://picsum.photos/200/200'
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data'
    })
  },
  mounted () {
    this.setCommentCount()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    async submitComment () {
      this.loading = true
      this.newPost.user_id = this.currentUser.id
      this.newPost.post_id = this.post.id
      await this.$axios.$post('/api/v1/posts', this.newPost)
        .then((res) => {
          this.commentCount = res
          this.loading = false
          this.dialog = false
          this.flashMessage({ message: 'コメントしました', type: 'primary', status: true })
          this.$refs.form.reset()
          if (this.isIndex) {
            this.$router.push(`/posts/${this.post.id}`)
          } else {
            this.fetchPost()
          }
        })
        .catch(() => {
          this.flashMessage({ message: 'コメントに失敗しました', type: 'error', status: true })
        })
    },
    setCommentCount () {
      this.$axios.$get(`api/v1/posts/${this.post.id}/commentcount`)
        .then((res) => {
          this.commentCount = res.comment_count
        })
        .catch((err) => {
          console.log(err)
        })
    },
    fetchPost () {
      this.$emit('fetchPost')
    }
  }
}
</script>
<style scoped>
  .btn-comment:hover {
    color: #2aa1f1;
  }
</style>
