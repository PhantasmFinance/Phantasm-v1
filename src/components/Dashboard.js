import React from 'react';
import { Row, Col } from 'antd';
import Icon from '@ant-design/icons';
import { Card, Avatar } from 'antd';
const { Meta } = Card;

export default function Dashboard(){
 
  return (
    <div>
        <Card
            className="Card"
            style={{ width: 300}}
            cover={<img alt="example" src="https://c.gitcoin.co/grants/b497f01f46c8a5ea4d3d1cdbff76348e/Frame_102_jpg.jpg" height="250px" />}
            actions={[<Icon type="setting" />, <Icon type="edit" />, <Icon type="ellipsis" />]}
        >
        <Meta
            className="Meta"
            title="Card title"
            description="This is the description"
        />
    </Card>
  </div>
  );
}
