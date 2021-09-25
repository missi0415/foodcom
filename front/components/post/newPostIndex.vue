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
      hide-details="false"
      />
      <v-container>
      <v-row>
        <v-col
          md="7"
          sm="7"
          xs="7"
          class="mt-5 mb-3"
        >
          <v-file-input
            @change="setImage"
            @click:clear="reSetPreviewImage"
            prepend-icon="mdi-camera"
            label="画像"
            truncate-length="20"
            accept="image/png, image/jpeg, image/bmp"
            hide-details="false"
          />
        </v-col>
        <v-col
          md="3"
          sm="3"
          xs="3"
          align="center"
          class="mt-4"
        >
          <v-img
            :src="previewImage"
            max-height="100"
            max-width="100"
            contain
          />
        </v-col>
        <v-col
          md="2"
          sm="2"
          xs="2"
          class="d-flex justify-end"
        >
          <v-btn
            :disabled="!isValid || loading"
            :loading="loading"
            rounded
            depressed
            color="blue"
            class="mt-8 white--text"
            @click="newPost"
          >
            投稿する
          </v-btn>
        </v-col>
      </v-row>
    </v-container>
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
