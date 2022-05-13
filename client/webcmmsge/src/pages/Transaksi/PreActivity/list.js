import React, { Component } from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// import react0router dom
import { Link } from 'react-router-dom'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

class List extends Component {
    constructor(props) {
        super(props)
        this.state = {
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
                // {
                //     headerName: 'Action',
                //     editable: false,
                //     sortable: false,
                //     filter: false,
                //     floatingFilter: false,
                //     field: 'idmesin',
                //     cellRenderer: (params) => <div><button type='button' className='btn btn-success'>Ubah</button></div>
                // }
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

    componentDidMount() {
        this.loadDataActivity("0")
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
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                <div className="md:container md:mx-auto mt-3">
                    <div className='grid grid-cols-6 gap-4 '>
                        <div className='col-start-1 col-end-3'>
                            {/* /// name page */}
                            <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                                Data Pre-Activity
                            </h1>
                        </div>
                        {/* /// button tambah */}
                        <div className='col-end-7 col-span-2'>
                            <div className="flex-auto justify-center items-center mt-6">
                                <Link to='/addpreactivity'>
                                    <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-700">Tambah Pre-Activity</button>
                                </Link>
                            </div>
                        </div>
                    </div>
                    {/* /// condition to load data grid komponent */}
                    <div className='ag-theme-alpine' style={{ height: '100vh' }}>
                        <AgGridReact
                            suppressExcelExport={true}
                            rowData={this.state.dataActivity}
                            columnDefs={this.state.columnDefs}
                            gridOptions={this.state.gridOptions}
                            animateRows={true}
                            defaultColDef={this.state.defaultColDef}
                            loadingCellRendererParams={this.state.loadingCellRendererParams}
                        />
                    </div>
                </div>
            </>
        );
    }
}

export default List;
