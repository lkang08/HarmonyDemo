// 渲染出Person对象的名称和Observed数组<string>中的第一个号码
import { Address, AddressBook, ObservedArray, Person } from '../model/Model';

// 为了更新电话号码，这里需要@ObjectLink person和@ObjectLink phones，
// 不能使用this.person.phones，内部数组的更改不会被观察到。
// 在AddressBookView、PersonEditView中的onClick更新selectedPerson
@Component
struct PersonView {
  @ObjectLink person: Person;
  @ObjectLink phones: ObservedArray<string>;
  @Link selectedPerson: Person;

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
      Text(this.person.name)
      if (this.phones.length) {
        Text(this.phones[0])
      }
    }
    .height(55)
    .backgroundColor(this.selectedPerson.name == this.person.name ? "#ffa0a0" : "#ffffff")
    .onClick(() => {
      this.selectedPerson = this.person;
    })
  }
}
// 渲染Person的详细信息
// @Prop装饰的变量从父组件AddressBookView深拷贝数据，将变化保留在本地, TextInput的变化只会在本地副本上进行修改。
// 点击 "Save Changes" 会将所有数据的复制通过@Prop到@Link, 同步到其他组件
@Component
struct PersonEditView {
  @Consume addrBook: AddressBook;
  /* 指向父组件selectedPerson的引用 */
  @Link selectedPerson: Person;
  /*在本地副本上编辑，直到点击保存*/
  @Prop name: string = "";
  @Prop address: Address = new Address("", 0, "");
  @Prop phones: ObservedArray<string> = [];
  selectedPersonIndex(): number {
    return this.addrBook.contacts.findIndex((person: Person) => person.id_ == this.selectedPerson.id_);
  }
  build() {
    Column() {
      TextInput({ text: this.name })
        .onChange((value) => {
          this.name = value;
        })
      TextInput({ text: this.address.street })
        .onChange((value) => {
          this.address.street = value;
        })
      TextInput({ text: this.address.city })
        .onChange((value) => {
          this.address.city = value;
        })
      TextInput({ text: this.address.zip.toString() })
        .onChange((value) => {
          const result = Number.parseInt(value);
          this.address.zip = Number.isNaN(result) ? 0 : result;
        })
      if (this.phones.length > 0) {
        ForEach(this.phones,
          (phone: ResourceStr, index?:number) => {
            TextInput({ text: phone })
              .width(150)
              .onChange((value) => {
                console.log(`${index}. ${value} value has changed`)
                this.phones[index!] = value;
              })
          },
          (phone: ResourceStr, index?:number) => `${index}`
        )
      }
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text("Save Changes")
          .onClick(() => {
            // 将本地副本更新的值赋值给指向父组件selectedPerson的引用
            // 避免创建新对象，在现有属性上进行修改
            this.selectedPerson.name = this.name;
            this.selectedPerson.address = new Address(this.address.street, this.address.zip, this.address.city)
            this.phones.forEach((phone: string, index: number) => {
              this.selectedPerson.phones[index] = phone
            });
          })
        if (this.selectedPersonIndex() != -1) {
          Text("Delete Contact")
            .onClick(() => {
              let index = this.selectedPersonIndex();
              console.log(`delete contact at index ${index}`);
              // 删除当前联系人
              this.addrBook.contacts.splice(index, 1);
              // 删除当前selectedPerson，选中态前移一位
              index = (index < this.addrBook.contacts.length) ? index : index - 1;
              // 如果contract被删除完，则设置me为选中态
              this.selectedPerson = (index >= 0) ? this.addrBook.contacts[index] : this.addrBook.me;
            })
        }
      }
    }
  }
}
@Component
export struct AddressBookView {
  @ObjectLink me: Person;
  @ObjectLink contacts: ObservedArray<Person>;
  @State selectedPerson: Person = new Person("", "", 0, "", []);
  aboutToAppear() {
    this.selectedPerson = this.me;
  }
  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      Text("Me:")
      PersonView({
        person: this.me,
        phones: this.me.phones,
        selectedPerson: this.selectedPerson
      })
      Divider().height(8)
      ForEach(this.contacts, (contact: Person) => {
        PersonView({
          person: contact,
          phones: contact.phones as ObservedArray<string>,
          selectedPerson: this.selectedPerson
        })
      },
        (contact: Person): string => { return contact.id_; }
      )
      Divider().height(8)
      Text("Edit:").margin({top:20})
      PersonEditView({
        selectedPerson: this.selectedPerson,
        name: this.selectedPerson.name,
        address: this.selectedPerson.address,
        phones: this.selectedPerson.phones
      })
    }
    .borderStyle(BorderStyle.Solid).borderWidth(5).borderColor(0xAFEEEE).borderRadius(5)
  }
}