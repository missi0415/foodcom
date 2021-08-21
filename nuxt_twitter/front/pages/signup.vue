<template>
  <!-- eslint-disable-next-line -->
  <bef-login-form-card #form-card-content>
    <v-form
      v-model="isValid"
    >
      <user-form-name
        :name.sync="params.user.name"
      />
      <user-form-email
        :email.sync="params.user.email"
      />
      <user-form-password
        :password.sync="params.user.password"
      />
    </v-form>
      <v-btn
        :disabled="!isValid"
        block
        color="myblue"
        class="white--text"
      >
        登録する
      </v-btn>
      <v-card-text>
        {{ params }}
      </v-card-text>
  </bef-login-form-card>
</template>

<script>
import BefLoginFormCard from '../components/beforeLogin/befLoginFormCard.vue'
import userFormEmail from '../components/user/userFormEmail.vue'
import userFormName from '../components/user/userFormName.vue'
import userFormPassword from '../components/user/userFormPassword.vue'
export default {
  components: { userFormName, userFormEmail, userFormPassword, BefLoginFormCard },
  layout: 'beforeLogin',
  data () {
    return {
      isValid: false,
      params: { user: { neme: '', email: '', password: '' } }
    }
  }
}
</script>
