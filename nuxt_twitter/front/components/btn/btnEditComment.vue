<template>
  <div>
    <v-btn
      :color="color"
      text
      rounded
      @click.prevent.stop="dialog = true"
    >
      編集
      <v-icon v-text="'mdi-lead-pencil'" />
    </v-btn>
    <v-dialog
      v-model="dialog"
      width="500"
    >
      <v-card>
        <v-card-text>
          btnEditComment.Vue {{ isPostComment }}
        </v-card-text>
        {{ comment }}
        {{ comment.post_id }}
        <div class="d-flex">
          <v-card-title>
            投稿編集
          </v-card-title>
          <v-spacer />
          <v-btn
            icon
            @click="dialog = false"
          >
            ✖︎
          </v-btn>
        </div>
        <v-container>
          <v-form
            ref="form"
            v-model="isValid"
          >
            <edit-comment-form-content
              :content.sync="newComment.content"
            />
            <v-btn
              :disabled="!isValid || loading"
              :loading="loading"
              block
              color="info"
              @click="updateComment"
            >
              更新する
            </v-btn>
          </v-form>
        </v-container>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import editCommentFormContent from '../post/editPostFormContent.vue'
export default {
  components: {
    editCommentFormContent
  },
  props: {
    comment: {
      type: Object,
      required: true
    },
    isPostComment: {
      type: Boolean,
      required: true
    }
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      color: 'deep-purple lighten-2',
      newComment: { content: '' }
    }
  },
  created () {
    this.newComment.content = this.comment.content
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage',
      setPost: 'post/setPost',
      setComment: 'comment/setComment',
      setComments: 'comment/setComments'
    }),
    async updateComment () {
      this.loading = true
      // newCommentというオブジェクトに.post_idとしてcomment.post_idを入れている
      // this.comment.post_id は親コンポーネントからきてる値
      console.log('newComment', this.newComment)
      await this.$axios.$patch(`/api/v1/comments/${this.comment.id}`, this.newComment)
      // $axios.$patch(url,第2引数に送りたい値)
        .then((res) => {
          this.setComment(res)
          this.flashMessage({ message: '更新しました', type: 'primary', status: true })
          if (this.isPostComment) {
            // postに対するcommentなら
            this.fetchPostContents()
          } else {
            // commentに対するcomment
            this.fetchCommentContents()
          }
          this.loading = false
          this.dialog = false
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.log(err.response)
          this.flashMessage({ message: err.response.data.message.join('\n'), type: 'error', status: true })
          this.loading = false
        })
    },
    async fetchPostContents () {
      console.log('btnEditComent', this.comment.post_id)
      const url = `/api/v1/posts/${this.comment.post_id}`
      await this.$axios.get(url)
        .then((res) => {
          this.setPost(res.data)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async fetchCommentContents () {
      const url = `/api/v1/search_comments/${this.comment.comment_id}`
      await this.$axios.get(url)
        .then((res) => {
          this.setComments(res.data)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.log(err)
        })
    }
  }
}
</script>
