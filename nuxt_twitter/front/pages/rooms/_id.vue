<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card
      outlined
      elevation="15"
    >
    <!-- firebase.firestore()= -->
      <v-card-text>
        page account/account.vue
      </v-card-text>
      <v-card-text>
        相手user{{ user }}
      </v-card-text>
      <v-card-text>
        自分currentuser {{ currentUser }}
      </v-card-text>
      <v-card-text>
        firestoredata {{ messages }}
      </v-card-text>
      <v-card-text>
        chats {{ chats }}
      </v-card-text>
      <v-form>
        <v-text-field
          v-model="message"
          label="メッセージを入力"
        >
        </v-text-field>
        <v-btn
          @click="onSubmit"
        >
        送信
        </v-btn>
      </v-form>
    </v-card>
  </layout-main>
</template>

<script>
import { mapGetters } from 'vuex'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
import firebase from '~/plugins/firebase'
// import firebase from '~/plugins/firebase'
export default {
  components: {
    layoutMain
  },
  data () {
    return {
      user: { id: '', name: '', avatar: '' },
      // rooms: [],
      message: '',
      messages: [],
      chats: []
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated'
      // chats: 'chats/chats'
    })
  },
  mounted () {
    setTimeout(() => {
      this.fetchUser()
      this.fetchMessage()
    }, 100)
  },
  methods: {
    async fetchUser () {
      const url = `/api/v1/users/${this.$route.params.id}`
      await this.$axios.get(url)
        .then((res) => {
          this.user.id = res.data.user.id
          this.user.name = res.data.user.name
          this.user.avatar = res.data.user.avatar.url
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async onSubmit () {
      // 登録データを準備
      const chat = {
        userId: this.currentUser.uid,
        name: this.currentUser.name,
        message: this.message,
        createdAt: new Date()
      }
      // 投稿データをfirestoreに送信 //
      await firebase.firestore()
        .collection('rooms')
        .doc(this.$route.params.id)
        .collection('chats')
        .add(chat)
      this.resetForm()
      this.fetchMessage()
      // this.scrollBottom()
    },
    resetForm () {
      this.message = ''
    },
    fetchMessage () {
      const chats = []
      firebase.firestore().collection('rooms').doc(this.$route.params.id).collection('chats').get()
        .then((res) => {
          console.log('res', res)
          res.forEach((doc) => {
            chats.push(doc.data())
            this.chats = chats
            console.log('doc.data()', doc.data())
          })
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}

</script>
