<template>
  <div>
    <div
      class="my-2"
      v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm || $vuetify.breakpoint.xs"
    >
      <v-btn
        color="blue"
        fab
        x-large
        dark
        @click="dialog = true"
      >
        <v-icon>mdi-feather</v-icon>
      </v-btn>
    </div>
    <div
      v-else
      class="my-2"
    >
      <v-btn
        color="blue"
        x-large
        rounded
        dark
        block
        @click="dialog = true"
      >
        ツイートする
      </v-btn>
    </div>
    <v-dialog
      v-model="dialog"
      width="500"
    >
      <v-card>
        <div class="d-flex">
          <v-card-title>
            新規投稿
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
            <new-post-form-content
              :content.sync="post.content"
            />
            <v-file-input
              @change="setImage"
              label="画像"
              accept="image/png, image/jpeg, image/bmp"
            />
            <v-btn
              :disabled="!isValid || loading"
              :loading="loading"
              block
              color="info"
              @click="newPost"
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
import newPostFormContent from './newPostForm.vue'
export default {
  components: {
    newPostFormContent
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      post: { content: '' },
      image: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data'
    })
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage',
      setPosts: 'post/setPosts'
    }),
    fetchContents () {
      this.$axios.get('/api/v1/posts')
        .then((res) => {
          this.setPosts(res.data)
        })
    },
    setImage (e) {
      this.image = e
    },
    async newPost () {
      this.loading = true
      const formData = new FormData()
      formData.append('post[image]', this.image)
      formData.append('post[content]', this.post.content)
      formData.append('post[user_id]', this.currentUser.id)
      console.log('送信データformData', formData)
      const config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      }
      // this.post.user_id = this.currentUser.id
      await this.$axios.$post('/api/v1/posts', formData, config)
        .then((res) => {
          console.log('post投稿のレスポンス', res)
          this.flashMessage({ message: '投稿しました', type: 'primary', status: true })
          this.loading = false
          this.$router.push('/posts')
          this.dialog = false
          this.$refs.form.reset()
        })
        .catch((err) => {
          this.flashMessage({ message: err.response.data.message.join('\n'), type: 'error', status: true })
          this.loading = false
        })
    }
  }
}
</script>
