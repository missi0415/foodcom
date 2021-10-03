<template>
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      persistent
      width="500"
    >
      <template #activator="{ on, attrs }">
        <v-btn
          color="primary"
          :dialog="dialog"
          block
          v-bind="attrs"
          v-on="on"
        >
          退会手続き
        </v-btn>
      </template>
      <v-card>
        <v-card-title class="text-h5">
          退会手続き
        </v-card-title>
        <v-card-text>
          退会します。よろしいですか？<br>
          この操作は取り消せません。<br>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn
            rounded
            color="primary"
            @click="dialog = false"
          >
            キャンセル
          </v-btn>
          <v-btn
            rounded
            color="error"
            @click="userUnsubscribe"
          >
            退会する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>
<script>
import { mapGetters, mapActions } from 'vuex'
import firebase from '~/plugins/firebase'
export default {
  data () {
    return {
      dialog: false
    }
  },
  computed: {
    ...mapGetters({
      currentUserId: 'auth/currentUserId',
      currentUser: 'auth/data'
    })
  },
  methods: {
    ...mapActions({
      logout: 'auth/logout',
      flashMessage: 'flash/flashMessage'
    }),
    userUnsubscribe () {
      const formData = new FormData()
      formData.append('user[is_active]', false)
      const url = `api/v1/users/${this.currentUserId}`
      this.$axios.patch(url, formData)
        .then(() => {
          this.logout()
          this.deleteUser()
          this.flashMessage({ message: '退会しました', type: 'primary', status: true })
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    deleteUser () {
      const user = firebase.auth().currentUser
      user.delete()
    }
  }
}
</script>
