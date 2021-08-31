<template>
  <div>
    <div
      class="my-2"
    >
      <v-btn
        color="white"
        x-large
        rounded
        @click="dialog = true"
      >
      <v-icon>mdi-pencil</v-icon>
        プロフィールを編集
      </v-btn>
    </div>
    <v-dialog
      v-model="dialog"
      width="800"
    >
      <v-container>
        <v-row justify="space-around">
          <v-card>
          <v-app-bar
            flat
            color="rgba(0, 0, 0, 0)"
          >
            <v-btn
              icon
              large
              class="pr-5"
              @click="dialog = false"
            >
              ✖︎
            </v-btn>
            <v-toolbar-title>
              プロフィールを編集
            </v-toolbar-title>
            <v-spacer />
            <v-btn
              icon
              rounded
              large
              color="dark"
              dark
            >
              <v-icon>保存</v-icon>
            </v-btn>
          </v-app-bar>
          <v-img
            height="200px"
            src="https://cdn.pixabay.com/photo/2020/07/12/07/47/bee-5396362_1280.jpg"
          />
          <v-card-title>
            <v-avatar size="56">
              <img
                alt="user"
                src="https://cdn.pixabay.com/photo/2020/06/24/19/12/cabbage-5337431_1280.jpg"
              >
            </v-avatar>
            <p class="ml-3 mt-3">
            </p>
            <v-spacer />
          </v-card-title>
          <v-card-title>
            <div class="font-weight-bold ml-8 mb-2">
              よろしくおねがいします
            </div>
            </v-card-title>
            {{ currentUser }}
            <v-container>
              <v-form
                ref="form"
                v-model="isValid"
              >
                // nameのフォーム
                <user-form-name
                  :name="user.name"
                />
                <user-form-email
                  :email="user.email"
                />
                <user-form-password
                  :password="user.password"
                />
                <v-file-input
                  @change="setImage"
                  label="アバター画像"
                  accept="image/png, image/jpeg, image/bmp"
                />
              <v-btn
                :disabled="!isValid || loading"
                :loading="loading"
                block
                color="info"
                @click="newPost"
              >
                保存する
              </v-btn>
              </v-form>
            </v-container>
          </v-card>
        </v-row>
      </v-container>
    </v-dialog>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import userFormEmail from './userFormEmail.vue'
import userFormName from './userFormName.vue'
import userFormPassword from './userFormPassword.vue'
export default {
  components: {
    userFormEmail,
    userFormPassword,
    userFormName
  },
  props: {
    currentUser: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      user: { id: '', name: '', email: '', password: '', avatar: '', introduction: '' },
      image: ''
    }
  },
  mounted () {
    this.userDataSet()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    userDataSet () {
      this.user.id = this.currentUser.id
      this.user.name = this.currentUser.name
      this.user.email = this.currentUser.email
      this.user.password = this.currentUser.password
      this.user.avatar = this.currentUser.avatar
    },
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
      formData.append('post[post_image]', this.image)
      formData.append('post[content]', this.post.content)
      formData.append('post[user_id]', this.currentUser.id)
      console.log('送信データformData', formData)
      const config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      }
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
