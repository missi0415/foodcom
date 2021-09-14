<template>
  <v-text-field
    v-model="setEmail"
    :rules="rules"
    label="メールアドレス"
    :placeholder="form.placeholder"
  />
</template>

<script>
export default {
  props: {
    email: {
      type: String,
      default: ''
    },
    noValidation: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      rules: [
        v => !!v || '',
        v => /.+@.+\..+/.test(v) || ''
      ]
    }
  },
  computed: {
    setEmail: {
      get () { return this.email },
      set (newVal) { return this.$emit('update:email', newVal) }
    },
    form () {
      const placeholder = this.noValidation ? undefined : 'your@email.com'
      return { placeholder }
    }
  }
}
</script>
