<template>
  <v-card
    class="ma-1 pl-2 pr-2"
    hover
    outlined
  >
    <v-form
      ref="form"
      v-model="isValid"
    >
      <v-text-field
      v-model="post.content"
      label="いまなにしてる？"
      :placeholder="form.placeholder"
      :rules="rules"
      />
      <div
        class="d-flex justify-space-between"
      >
        <v-img
          :src="previewImage"
          max-height="200"
          max-width="200"
          contain
        />
        <v-file-input
          @change="setImage"
          @click:clear="reSetPreviewImage"
          prepend-icon="mdi-camera"
          label="画像"
          truncate-length="14"
          accept="image/png, image/jpeg, image/bmp"
        />
        <v-btn
          :disabled="!isValid || loading"
          :loading="loading"
          rounded
          depressed
          color="blue"
          class="ma-2 white--text"
          @click="newPost"
        >
          ツイートする
        </v-btn>
      </div>
    </v-form>
  </v-card>
</template>
<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  data () {
    const max = 140
    return {
      max,
      isValid: false,
      loading: false,
      post: { content: '' },
      image: '',
      previewImage: '',
      rules: [
        v => !!v || '',
        v => (!!v && max >= v.length) || `${max}文字以内で入力してください`
      ]
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId'
    }),
    form () {
      const placeholder = this.noValidation ? undefined : 'コンテンツ'
      return { placeholder }
    }
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
    async newPost () {
      this.loading = true
      const formData = new FormData()
      formData.append('post[image]', this.image)
      formData.append('post[content]', this.post.content)
      formData.append('post[user_id]', this.currentUserId)
      if (typeof (this.image) === 'object') {
        formData.append('post[image]', this.image)
      }
      await this.$axios.$post('/api/v1/posts', formData)
        .then(() => {
          this.flashMessage({ message: '投稿しました', type: 'primary', status: true })
          this.loading = false
          this.fetchPost()
          this.dialog = false
          this.$refs.form.reset()
        })
    },
    fetchPost () {
      this.$emit('fetchPost')
    }
  }
}
</script>
