import React, { Component } from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";
/// react strap design form
import { ButtonDropdown, DropdownToggle, DropdownItem, DropdownMenu } from 'reactstrap'
/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

/// action button per item
const actionButton = (params) => { console.log(params) }

class List extends Component {

    constructor(props) {
        super(props)
        this.toggle = this.toggle.bind(this);
        this.state = {
            /// set tonggle dropdown
            dropdownOpen: false,
            /// state load data site for dropdown 
            dataSite: '',
            /// flag for handlind data grid if false data grid hide 
            loadingSite: false,
            /// setate load data activity
            Activity: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "No. Mesin",
                    field: 'nomesin',
                },
                {
                    headerName: "Mesin",
                    field: 'ketmesin',
                },
                {
                    headerName: "Activity",
                    field: 'masalah',
                },
                {
                    headerName: "Tanggal",
                    field: 'tanggal',
                },
                {
                    headerName: "jam",
                    field: 'jam',
                },
                {
                    headerName: "Jenis Activity",
                    field: 'jenis_masalah',
                },
                {
                    headerName: "Site",
                    field: 'site',
                },
                {
                    headerName: "Shift",
                    field: 'shift',
                },
                {
                    headerName: "Status",
                    field: 'statusselesai',
                },
                {
                    headerName: "Pengguna",
                    field: 'pengguna',
                },
                {
                    headerName: 'Action',
                    editable: false,
                    sortable: false,
                    filter: false,
                    floatingFilter: false,
                    field: 'idmesin',
                    cellRenderer: (params) => {
                        <div>
                            <ButtonDropdown isOpen={this.state.dropdownOpen} toggle={this.toggle}>
                                <DropdownToggle caret color="danger">...</DropdownToggle>
                                <DropdownMenu>
                                    <DropdownItem header>Header</DropdownItem>
                                    <DropdownItem disabled>Action</DropdownItem>
                                    <DropdownItem>Another Action</DropdownItem>
                                    <DropdownItem divider />
                                    <DropdownItem>Another Action</DropdownItem>
                                    </DropdownMenu>
                                </ButtonDropdown>
                    </div>
                    }
                    
                }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: true,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }

    toggle() {
        this.setState({
          dropdownOpen: !this.state.dropdownOpen
        });
      }

    /// status handler
    statusselesai(params) {
        if (params.data.statusselesai === 0) {
            return 'Belum Selesai'
        } else if (params.data.statusselesai === 1) {
            return 'Sudah Selesai'
        } else {
            return 'Tidak diketahui'
        }
    }

    componentDidMount() {
        this.loadDataActivity("1")
    }

    /// getting data komponen from api with parameter idmesin
    async loadDataActivity(flag_activity) {
        console.log('asda', flag_activity)
        await axios.get("masalah/" + flag_activity + "/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ dataActivity: response.data.data })
        }).catch((error) => {
            console.log(error)
        }).finally(() => {
        })
    }

    render() {
        return (
            <div>
                {/* /// navigation bar */}
                <NavbarComponent />
                {/* /// header form */}
                <h1>Data Activity</h1>
                {/* /// condition to load data grid komponent */}

                <div className='ag-theme-alpine' style={{ height: '100vh', width: '100vw' }}>
                    <AgGridReact
                        suppressExcelExport={true}
                        rowData={this.state.dataActivity}
                        columnDefs={this.state.columnDefs}
                        // onGridReady={onGridReady}
                        gridOptions={this.state.gridOptions}
                        animateRows={true}
                        defaultColDef={this.state.defaultColDef}
                        loadingCellRendererParams={this.state.loadingCellRendererParams}
                    />
                </div>

            </div>
        );
    }
}

export default List;
