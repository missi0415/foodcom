<template>
  <v-text-field
    v-model="setintroduction"
    :rules="rules"
    :counter="max"
    label="自己紹介"
    placeholder="自己紹介内容"
    outlined
  />
</template>

<script>
export default {
  props: {
    introduction: {
      type: String,
      default: ''
    }
  },
  data () {
    const max = 140
    return {
      max,
      rules: [
        v => !!v || '',
        v => (!!v && max >= v.length) || `${max}文字以内で入力してください`
      ]
    }
  },
  computed: {
    setintroduction: {
      get () { return this.introduction },
      set (newVal) { return this.$emit('update:introduction', newVal) }
    }
  }
}
</script>
