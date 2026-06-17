#!/bin/bash

prefix="net测试-gitcode-fe-"
branch=$(git branch --show-current)

origin_huawei="https://codehub.devcloud.cn-north-4.huaweicloud.com/gitcode-fe00001/gitcode-fe.git"
#输出当前分支
echo "当前分支为 $branch"


# 二次确认
read -p "确定要将 $branch 分支部署到测试(.net)？(y/n)" confirm
if [[ $confirm != "y" ]]; then
    echo "已取消部署"
    exit 1
fi

# 执行其他逻辑
echo "当前分支为 $branch，可以执行部署操作"

# # 拉取对应分支代码
git pull origin $branch

#判断拉取是否成功
if [ $? -eq 0 ]; then
    echo "拉取成功"

    #推送到 origin-huawei 远程仓库
    # git push $origin_huawei $branch
    # 创建新标签
    new_tag=$(echo ${prefix}$(date +'%Y%m%d%H%M'))
    git tag ${new_tag}
    git push $origin_huawei $new_tag
    if [ $? -eq 0 ]; then

        #返回最近的commitid、对应的分支名
        commitid=$(git log -1 --pretty=format:%h)
        branch=$(git rev-parse --abbrev-ref HEAD)

        echo -e "\n*******************************************************************************************"
        echo "     华为云仓库分支($branch)、tag ($new_tag) 同步成功。"
        echo "     最近一次commitid为 $commitid, branch: $branch, tag: $new_tag"
        echo "     请到华为云查看：详情点击查看华为云：https://devcloud.cn-north-4.huaweicloud.com/cicd/project/faae1bd0a2b74a39a566c19189b117de/pipeline?v=1"
        echo -e "*******************************************************************************************\n"
    else
        echo "推送失败"
        exit 1
    fi
else
    echo "拉取失败"
    exit 1
fi

# 执行其他操作
# ...
