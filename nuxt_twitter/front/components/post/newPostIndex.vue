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
        <v-file-input
          @change="setImage"
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
    },
    async newPost () {
      this.loading = true
      const formData = new FormData()
      formData.append('post[image]', this.image)
      formData.append('post[content]', this.post.content)
      formData.append('post[user_id]', this.currentUserId)
      const config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      }
      await this.$axios.$post('/api/v1/posts', formData, config)
        .then(() => {
          this.flashMessage({ message: '投稿しました', type: 'primary', status: true })
          this.loading = false
          this.fetchPosts()
          this.dialog = false
          this.$refs.form.reset()
        })
    },
    fetchPosts () {
      this.$emit('fetchPosts')
    }
  }
}
</script>
