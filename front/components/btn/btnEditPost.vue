<template>
  <div>
    <v-tooltip bottom>
      <template #activator="{ on, attrs }">
        <v-btn
          icon
          class="btn-edit"
          v-bind="attrs"
          v-on="on"
          @click.prevent.stop="dialog = true"
        >
          <v-icon v-text="'mdi-pencil'" />
        </v-btn>
      </template>
      <span>編集</span>
    </v-tooltip>
    <v-dialog
      v-model="dialog"
      width="500"
    >
      <v-card>
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
            <edit-post-form-content
              :content.sync="content"
            />
            <v-img
              :src="previewImage"
              max-height="200"
              max-width="200"
              contain
            />
            <v-file-input
              @change="setImage"
              @click:clear="reSetPreviewImage"
              clearable
              prepend-icon="mdi-camera"
              label="画像"
              accept="image/png, image/jpeg, image/bmp"
            />
            <v-btn
              :disabled="!isValid || loading"
              :loading="loading"
              block
              color="info"
              @click="updatePost"
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
import { mapGetters, mapActions } from 'vuex'
import EditPostFormContent from '../post/editPostFormContent.vue'
export default {
  components: {
    EditPostFormContent
  },
  props: {
    post: {
      type: Object,
      required: true
    },
    isIndex: {
      type: Boolean,
      required: true
    }
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      content: '',
      image: '',
      previewImage: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUserId: 'auth/currentUserId'
    })
  },
  mounted () {
    this.content = this.post.content
    this.image = this.post.image.url
    this.previewImage = this.post.image.url
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    setImage (e) {
      this.image = e
      if (this.image !== null) {
        if (event.target.files.length !== 0) {
          this.previewImage = URL.createObjectURL(this.image)
        } else {
          this.reSetPreviewImage()
        }
      } else {
        this.reSetPreviewImage()
      }
    },
    reSetPreviewImage () {
      this.previewImage = this.post.image
      this.Image = ''
    },
    async updatePost () {
      this.loading = true
      const formData = new FormData()
      formData.append('post[content]', this.content)
      formData.append('post[user_id]', this.currentUserId)
      if (typeof (this.image) === 'object') {
        formData.append('post[image]', this.image)
      }
      await this.$axios.$patch(`/api/v1/posts/${this.post.id}`, formData)
        .then(() => {
          if (this.$route.name === 'users-id') {
            this.fetchUser()
          } else if (this.$route.name === 'posts-id' && this.isIndex === true) {
            this.fetchComment()
          } else if (this.isIndex) {
            this.fetchComment()
          } else {
            this.fetchPost()
            console.log('fetchpost')
          }
          this.flashMessage({ message: '更新しました', type: 'primary', status: true })
          this.loading = false
          this.dialog = false
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.log(err.response)
          this.flashMessage({ message: '更新に失敗しました', type: 'error', status: true })
          this.loading = false
        })
    },
    fetchPosts () {
      this.$emit('fetchPosts')
    },
    fetchPost () {
      this.$emit('fetchPost')
    },
    fetchUser () {
      this.$emit('fetchUser')
    },
    fetchComment () {
      this.$emit('fetchComment')
    }
  }
}
</script>
<style scoped>
  .btn-edit:hover {
    color: #02b97c;
  }
</style>
