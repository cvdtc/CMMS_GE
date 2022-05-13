import React, { Component } from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// react router dom
import { Link } from 'react-router-dom'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';
import swal from 'sweetalert';
import { Warning } from 'postcss';
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
                    field: 'idmasalah',
                    editable: false,
                    // cellRendererFramework: (params) => <div className='inline-flex rounded-md' role='group'><Link to='/editmasalah/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link><button onClick={(params) => this.MoreAction(params)} className="py-2 px-2 text-sm font-small rounded-r-lg border border-gray-300 bg-red-500 text-white">Action</button></div>
                    cellRendererFramework: (params) => <div><button onClick={() => this.MoreAction(params.data)} className="text-sm font-small rounded-lg bg-red-300 text-black">. . .</button></div>
                }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: false,
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

    /// modal konfirmasi
    async MoreAction(params) {

        swal({
            text: "Apa yang akan anda lakukan?", 
            buttons: {
                cancel: true
            },
            content: (
                <div>
                    <Link to='/editmasalah/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link>
                    <Link to='/editmasalah/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link>
                    <Link to='/editmasalah/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link>
                </div>
            )
        })

        /// old modal
        // swal("Apa yang akan anda lakukan?", {
        //     icon: "warning",
        //     dangerMode: true,
        //     buttons: {
        //         cancel: "Batal",
        //         edit: {
        //             text: "Edit",
        //             value: "edit"
        //         },
        //         timeline: {
        //             text: "Timeline",
        //             value: "timeline"
        //         },
        //         progress: {
        //             text: "progress",
        //             value: "progress"
        //         },
        //         penyelesaian: {
        //             text: "Penyelesaian",
        //             value: "penyelesaian"
        //         },
        //         detail: {
        //             text: "Detail",
        //             value: "detail"
        //         },
        //     }
        // }).then((value) => {
        //     console.log(value)
        //     switch (value) {
        //         case "edit":
        //             <Link to='/editmasalah/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link>
        //             break;

        //         default:
        //             break;
        //     }
        // })
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
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                <div className="md:container md:mx-auto mt-3">
                    <div className='grid grid-cols-6 gap-4 '>
                        <div className='col-start-1 col-end-3'>
                            {/* /// name page */}
                            <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                                Data Activity
                            </h1>
                        </div>
                        {/* /// button tambah */}
                        <div className='col-end-7 col-span-1'>
                            <div className="flex-auto justify-center items-center mt-6">
                                <Link to='/addactivity'>
                                    <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-700">Tambah Activity</button>
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
                            // onGridReady={onGridReady}
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
