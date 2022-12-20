<template>
  <div>
    <el-tabs v-model="activeName" @tab-click="">
      <el-tab-pane label="部门管理" name="DepMana"><DepMana></DepMana></el-tab-pane>
      <el-tab-pane label="职位管理" name="PosMana"><PosMana></PosMana></el-tab-pane>
      <el-tab-pane label="职称管理" name="JoblebelMana"><JoblebelMana></JoblebelMana></el-tab-pane>
      <el-tab-pane label="奖惩规则" name="EcMana"><EcMana></EcMana></el-tab-pane>
      <el-tab-pane label="权限组" name="PermissMana"><PermissMana></PermissMana></el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import DepMana from '../../components/sys/DepMana'
import EcMana from '../../components/sys/EcMana'
import JoblebelMana from '../../components/sys/JoblevelMana'
import PermissMana from '../../components/sys/PermissMana'
import PosMana from '../../components/sys/PosMana'

export default {
  name: "SysBasic",
  data(){
    return {
      activeName:'DepMana'
    }
  },
  components: {
    DepMana,
    EcMana,
    JoblebelMana,
    PermissMana,
    PosMana
  },
  methods:{

  }
}
</script>

<style scoped>

</style>