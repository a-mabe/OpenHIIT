import React from 'react';
import { FAB } from 'react-native-elements';

// import all the components we are going to use
import {
  SafeAreaView,
  StyleSheet,
  View,
  Image,
  TouchableOpacity,
  Text,
} from 'react-native';

const App = () => {
  const clickHandler = () => {
    //function to handle click on floating Action Button
    alert('Floating Button Clicked');
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.container}>
        <Text style={styles.titleStyle}>
          Example of React Native Floating Action Button
        </Text>
        <Text style={styles.textStyle}>
          Click on Action Button to see Alert
        </Text>
        <FAB
          icon={{ name: 'add', color: 'white' }}
          activeOpacity={0.7}
          onPress={clickHandler}
          style={styles.touchableOpacityStyle}>
        </FAB>
      </View>
    </SafeAreaView>
  );
};

export default App;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
    padding: 10,
  },
  titleStyle: {
    fontSize: 28,
    fontWeight: 'bold',
    textAlign: 'center',
    padding: 10,
  },
  textStyle: {
    fontSize: 16,
    textAlign: 'center',
    padding: 10,
  },
  touchableOpacityStyle: {
    position: 'absolute',
    width: 50,
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',
    right: 30,
    bottom: 30,
  },
  floatingButtonStyle: {
    resizeMode: 'contain',
    width: 50,
    height: 50,
    //backgroundColor:'black'
  },
});

// import React from 'react';
// import { View, Text, ScrollView, StyleSheet } from 'react-native';
// import { FAB } from 'react-native-elements';

// const App = () => {
//   const [visible, setVisible] = React.useState(true);
//   return (
//     <>
//       <ScrollView>
//         <FAB
//           style={styles.floatinBtn}
//           position="right"
//           visible={visible}
//           icon={{ name: 'add', color: 'white' }}
//           size="small"
//         />
//       </ScrollView>
//     </>
//   );
// };

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     justifyContent: 'center',
//     alignItems: 'center',
//   },
//   floatinBtn: {
//     position: 'fixed',
//     bottom: 10,
//     right: 10,
//   }
// });

// export default App;